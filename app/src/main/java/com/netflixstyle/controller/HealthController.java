package com.netflixstyle.controller;

import java.util.Map;
import org.springframework.http.ResponseEntity;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class HealthController {
    private final JdbcTemplate jdbcTemplate;

    public HealthController(JdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }

    @GetMapping("/api/health")
    public Map<String, String> health() {
        return Map.of("status", "UP", "service", "netflix-style-3-tier-application");
    }

    @GetMapping("/api/db-health")
    public ResponseEntity<Map<String, String>> databaseHealth() {
        try {
            Integer result = jdbcTemplate.queryForObject("SELECT 1", Integer.class);
            return ResponseEntity.ok(Map.of("database", result != null && result == 1 ? "UP" : "DOWN"));
        } catch (Exception ex) {
            return ResponseEntity.status(503).body(Map.of("database", "DOWN"));
        }
    }
}