package com.mealmanager.model;

import com.mealmanager.enumeration.MonthlyRole;
import jakarta.persistence.*;

@Entity
@Table(name = "month_user_roles")
public class MonthUserRole {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne
    @JoinColumn(name = "user_id")
    private User user;

    @ManyToOne
    @JoinColumn(name = "month_id")
    private Month month;

    @Enumerated(EnumType.STRING)
    private MonthlyRole role;

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public MonthlyRole getRole() {
        return role;
    }

    public void setRole(MonthlyRole role) {
        this.role = role;
    }

    public Month getMonth() {
        return month;
    }

    public void setMonth(Month month) {
        this.month = month;
    }

    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
    }
}