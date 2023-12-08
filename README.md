# SQL-date-validation

Date constraint solution

## Prerequisites

PgAdmin4

A test database

## Usage

Using the SQL queries you will be able to
1. Create a testtable
2. Insert dummy data
3. Add trigger to throw exception for invalid date combinations
4. Test the trigger using test cases provided



### Query to create test table for testing
```sql
CREATE TABLE testproject (
    ID SERIAL,
    project_code VARCHAR(255),
    startdate DATE,
    enddate DATE,
    PRIMARY KEY (ID)
);
```

### Query to insert some dummy data

```sql
INSERT INTO testproject (project_code, start_date, end_date)
VALUES 
('Project1', '2023-01-01', '2023-12-31'),
('Project2', '2023-02-01', '2023-12-31');
```
### Query to add triggers to check dates

```sql
CREATE OR REPLACE FUNCTION check_dates()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.end_date IS NOT NULL AND NEW.start_date IS NULL THEN
        RAISE EXCEPTION '1';
    ELSIF NEW.end_date < NEW.start_date THEN
        RAISE EXCEPTION '2';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER date_trigger
BEFORE INSERT OR UPDATE ON testproject
FOR EACH ROW EXECUTE PROCEDURE check_dates();
```
#### Error code description
Error code 1 : End date is present but start date is null


Error code 2 : End date is less than start date it cannot be less than start date

### Queries to check the validation

#### Valid set of dates

1. Start date < end date

```sql
INSERT INTO testproject (project_code, start_date, end_date)
VALUES 
('Project3', '2023-01-01', '2023-12-31');
```

2. Not null start date and null end date

```sql
INSERT INTO testproject (project_code, start_date, end_date)
VALUES ('Project4', '2023-01-01', NULL);
```

3. Null start_date and null end_date

```sql
INSERT INTO testproject (project_code, start_date, end_date)
VALUES 
('Project5',NULL, NULL);
```

#### Invalid set of dates

1. Start date > end date

```sql
INSERT INTO testproject (project_code, start_date, end_date)
VALUES ('Project6', '2023-12-31', '2023-01-01');
```

2. Null start date and a not null end date

```sql
INSERT INTO testproject (project_code, start_date, end_date)
VALUES ('Project4', NULL, '2023-12-31');
```
