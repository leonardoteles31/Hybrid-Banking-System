package src.main.java.com.leodev.hybrid_banking_system.model;

import jakarta.persistence.*;
import lombok.*;

import java.math.bigDecimal;

@Getter @Setter
@NoArgsConstructor @AllArgsConstructor
@Builder
@Entity
@Table(name = "accounts")
public class Account {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, unique = true, length = 30)
    private String number;

    @Column(nullable = false, precision = 19, scale = 2)
    private bigDecimal balance;
}
