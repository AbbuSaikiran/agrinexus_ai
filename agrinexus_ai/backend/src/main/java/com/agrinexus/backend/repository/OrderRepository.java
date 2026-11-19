package com.agrinexus.backend.repository;

import com.agrinexus.backend.model.entity.Order;
import com.agrinexus.backend.model.enums.OrderStatus;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface OrderRepository extends JpaRepository<Order, Long> {
    List<Order> findByBuyerIdOrderByCreatedAtDesc(Long buyerId);
    List<Order> findByProductFarmerIdOrderByCreatedAtDesc(Long farmerId);
    List<Order> findByStatus(OrderStatus status);
    long countByBuyerIdAndStatus(Long buyerId, OrderStatus status);
}
