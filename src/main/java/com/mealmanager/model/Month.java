package com.mealmanager.model;

import jakarta.persistence.*;
import java.time.LocalDate;
import java.util.List;

@Entity
@Table(name = "months")
public class Month {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String monthName;

    private LocalDate startDate;

    private LocalDate endDate;

    private boolean isActive;

    @OneToMany(mappedBy = "month", cascade = CascadeType.ALL)
    private List<MonthUserRole> monthUserRoles;

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getMonthName() {
        return monthName;
    }

    public void setMonthName(String monthName) {
        this.monthName = monthName;
    }

    public LocalDate getStartDate() {
        return startDate;
    }

    public void setStartDate(LocalDate startDate) {
        this.startDate = startDate;
    }

    public LocalDate getEndDate() {
        return endDate;
    }

    public void setEndDate(LocalDate endDate) {
        this.endDate = endDate;
    }

    public boolean isActive() {
        return isActive;
    }

    public void setActive(boolean active) {
        isActive = active;
    }

    public List<MonthUserRole> getMonthUserRoles() {
        return monthUserRoles;
    }

    public void setMonthUserRoles(List<MonthUserRole> monthUserRoles) {
        this.monthUserRoles = monthUserRoles;
    }
}