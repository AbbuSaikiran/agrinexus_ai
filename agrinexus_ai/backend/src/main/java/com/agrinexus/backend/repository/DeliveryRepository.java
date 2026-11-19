package com.agrinexus.backend.repository;

import com.agrinexus.backend.model.entity.Delivery;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface DeliveryRepository extends JpaRepository<Delivery, Long> {
    Optional<Delivery> findByOrderId(Long orderId);
    List<Delivery> findByPartnerId(Long partnerId);
    List<Delivery> findByStatus(String status);
}
