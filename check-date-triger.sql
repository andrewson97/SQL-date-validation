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