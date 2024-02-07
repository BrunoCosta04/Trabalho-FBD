--Only lets a new subscription to an email be set when the last subscription is already paid
-- and the last subscription is already finished.


-- This trigger is set to postgres SQL using the plpgsql language that is exclusive to postgres.











CREATE OR REPLACE FUNCTION check_last_subscription_paid()
RETURNS TRIGGER AS $$
DECLARE
    last_payment_status VARCHAR(20);
    last_signing_date DATE;
    last_duration_sub SMALLINT;
BEGIN
    -- Get the month that ends the last subscription
    SELECT signingDate, durationSub INTO last_signing_date, last_duration_sub
    FROM _Subscription
    WHERE  email = NEW.email 
    ORDER BY signingDate DESC
    LIMIT 1;


	-- Get the last payment status for the email being inserted
    SELECT paymentStatus INTO last_payment_status
    FROM _Subscription
    WHERE email = NEW.email
    ORDER BY signingDate DESC
    LIMIT 1;


    IF DATE_TRUNC('month', last_signing_date) + (last_duration_sub || ' months')::interval+
 					 (last_signing_date - DATE_TRUNC('month', last_signing_date))::interval < NEW.signingDate THEN
        IF  last_payment_status IS NULL OR last_payment_status = 'paid' OR last_payment_status = 'Paid' THEN
			RETURN NEW;
		ELSE
			RAISE EXCEPTION 'Cannot insert new subscription for email % because the last subscription is not paid.', NEW.email;
		END IF;
    ELSE 
        RAISE EXCEPTION 'The last subscription on email % is still ongoing.', NEW.email;
    END IF;


    
    
    
    
END;
$$ LANGUAGE plpgsql;






CREATE TRIGGER check_last_subscription_paid_trigger
BEFORE INSERT ON _Subscription
FOR EACH ROW
EXECUTE FUNCTION check_last_subscription_paid();