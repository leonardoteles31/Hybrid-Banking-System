package com.leodev.hybrid_banking_system.model;

import jakarta.persistence.*;
import lombok.*;

import java.math.BigDecimal;
import java.time.Instant;

/**
 * Represents a financial transaction in the Hybrid Banking System.
 *
 * Each transaction stores:
 * - The type of operation (TRANSFER, DEPOSIT, WITHDRAW)
 * - The monetary amount involved
 * - The source and/or destination accounts
 * - The current processing status
 *
 * Transactions are initially created with status PENDING
 * and later processed by the COBOL batch module.
 */
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
@Entity
@Table(name = "transactions")
public class Transaction {

    /**
     * Unique identifier of the transaction.
     * Generated automatically by the database.
     */
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    /**
     * Defines the business type of the transaction.
     * Stored as a String in the database for readability.
     */
    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 15)
    private TransactionType type;

    /**
     * Monetary amount involved in the transaction.
     * BigDecimal ensures precision in financial operations.
     */
    @Column(nullable = false, precision = 19, scale = 2)
    private BigDecimal amount;

    /**
     * Source account.
     * Used for TRANSFER and WITHDRAW operations.
     *
     * Many transactions can reference the same account.
     */
    @ManyToOne
    @JoinColumn(name = "from_account_id")
    private Account fromAccount;

    /**
     * Destination account.
     * Used in TRANSFER operations.
     *
     * Many transactions can reference the same account.
     */
    @ManyToOne
    @JoinColumn(name = "to_account_id")
    private Account toAccount;

    /**
     * Indicates the current processing state of the transaction.
     *
     * PENDING   → Not processed yet
     * PROCESSED → Successfully processed
     * FAILED    → Processing failed
     */
    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 15)
    private TransactionStatus status;

    /**
     * Timestamp representing when the transaction was created.
     * This field is immutable after creation.
     */
    @Column(nullable = false, updatable = false)
    private Instant createdAt;
}