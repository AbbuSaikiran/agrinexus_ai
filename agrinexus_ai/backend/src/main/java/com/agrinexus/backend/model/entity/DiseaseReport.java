package com.agrinexus.backend.model.entity;

import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDateTime;

@Entity
@Table(name = "disease_reports", indexes = {
    @Index(name = "idx_dr_farmer", columnList = "farmer_id")
})
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class DiseaseReport {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "farmer_id", nullable = false)
    private User farmer;

    @Column(nullable = false, length = 255)
    private String imageUrl;

    @Column(length = 150)
    private String disease;

    @Column
    private Double confidence;    // 0–100

    @Column(columnDefinition = "TEXT")
    private String advice;

    @Column(length = 20)
    private String severity;      // None | Low | Medium | High

    @Column(updatable = false)
    private LocalDateTime createdAt;

    @PrePersist protected void onCreate() { createdAt = LocalDateTime.now(); }
}
