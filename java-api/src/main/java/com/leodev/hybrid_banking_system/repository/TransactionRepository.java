package src.main.java.com.leodev.hybrid_banking_system.repository;

import src.main.java.com.leodev.hybrid_banking_system.model.Transaction;
import org.springframework.data.jpa.repository.JpaRepository;

public interface TransactionRepository extends JpaRepository<Transaction, Long> {
}
