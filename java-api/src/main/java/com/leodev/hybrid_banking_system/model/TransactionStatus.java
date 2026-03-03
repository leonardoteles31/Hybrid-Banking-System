package com.leodev.hybrid_banking_system.model;

/**
 * Represents the processing state of a transaction.
 *
 * It indicates whether the transaction has been
 * processed by the COBOL batch system or not
 */
public enum TransactionStatus {

    /**
     * Transaction was created but not yet processed.
     */
    PENDING,

    /**
     * Transaction was successfully processed.
     */
    PROCESSED,

    /**
     * Transaction processing failed.
     */
    FAILED
}
