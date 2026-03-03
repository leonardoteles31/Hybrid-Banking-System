package src.main.java.com.leodev.hybrid_banking_system.model;

/**
 * Defines the business type of a transaction.
 *
 * This represents what kind of financial operation
 * is being executed.
 */
public enum TransactionType {

    /**
     * Tranfers money from one account to another.
     */
    TRANSFER,

    /**
     * Adds money to an account.
     */
    DEPOSIT,

    /**
     * Removes money from an account.
     */
    WITHDRAW
}
