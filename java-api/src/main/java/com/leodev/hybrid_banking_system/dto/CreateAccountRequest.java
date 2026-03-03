package src.main.java.com.leodev.hybrid_banking_system.dto;

import jakarta.validation.constraints.*;
import java.math.BigDecimal;

/**
 * DTO used to create a new bank account.
 *
 * This record defines the expected JSON payload for the API.
 * Bean Validation annotations (@NotBlank, @Size, @NotNull, @DecimalMin)
 * ensure invalid data is rejected before reaching the service layer.
 */
public record CreateAccountRequest(

        /**
         * Unique account number (e.g., "ACC001").
         * Must not be blank and must have 3 to 30 characters.
         */
        @NotBlank @Size(min = 3, max = 30)
        String number,

        /**
         * Initial balance for the account.
         * Must not be null and cannot be negative.
         */
        @NotNull @DecimalMin(value = "0.00")
        BigDecimal initialBalance
) {}
