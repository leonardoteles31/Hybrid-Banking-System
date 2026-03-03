package src.main.java.com.leodev.hybrid_banking_system.dto;

import src.main.java.com.leodev.hybrid_banking_system.model.TransactionType;
import jakarta.validation.constraints.*;

import java.math.BigDecimal;

/**
 * DTO used to create a new transaction.
 *
 * NOTE:
 * - Basic validation is done here (type and amount).
 * - Rules that depend on the transaction type (e.g., TRANSFER needs both accounts)
 *   are validated in the service layer (business validation).
 */
public record CreateTransactionRequest(

        /**
         * Type of the transaction (TRANSFER, DEPOSIT, WITHDRAW).
         */
        @NotNull
        TransactionType type,

        /**
         * Transaction amount.
         * Must be greater than zero.
         */
        @NotNull @DecimalMin(value = "0.01")
        BigDecimal amount,

        /**
         * Source account number.
         * Required for TRANSFER and WITHDRAW.
         * For DEPOSIT, it represents the target account (where money goes in).
         */
        String fromAccountNumber,

        /**
         * Destination account number.
         * Required only for TRANSFER.
         */
        String toAccountNumber
) {}
