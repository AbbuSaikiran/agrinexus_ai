package com.agrinexus.backend.repository;

import com.agrinexus.backend.model.entity.DiseaseReport;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface DiseaseReportRepository extends JpaRepository<DiseaseReport, Long> {
    List<DiseaseReport> findByFarmerIdOrderByCreatedAtDesc(Long farmerId);
}
