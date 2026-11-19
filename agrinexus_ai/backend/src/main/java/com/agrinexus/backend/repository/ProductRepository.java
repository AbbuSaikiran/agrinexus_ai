package com.agrinexus.backend.repository;

import com.agrinexus.backend.model.entity.Product;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface ProductRepository extends JpaRepository<Product, Long> {
    List<Product> findByFarmerId(Long farmerId);
    List<Product> findByStatus(String status);
    List<Product> findByCategoryIgnoreCaseAndStatus(String category, String status);

    @Query("SELECT p FROM Product p WHERE p.status = 'AVAILABLE' AND " +
           "(:query IS NULL OR LOWER(p.name) LIKE LOWER(CONCAT('%', :query, '%')) OR " +
           "LOWER(p.location) LIKE LOWER(CONCAT('%', :query, '%')))")
    List<Product> searchAvailable(@Param("query") String query);
}
