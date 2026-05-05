package com.mealmanager.repository;

import com.mealmanager.model.MonthUserRole;
import com.mealmanager.model.User;
import com.mealmanager.model.Month;
import io.micrometer.common.lang.NonNull;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;
import java.util.Optional;

public interface MonthUserRoleRepository extends JpaRepository<MonthUserRole, Long> {
    Optional<MonthUserRole> findByUserAndMonth(User user, Month month);
    List<MonthUserRole> findByUserIdAndMonthId(Long userId, Long monthId);
    List<MonthUserRole> findByMonth(Month month);

    @Query("SELECT r FROM MonthUserRole r JOIN FETCH r.user WHERE r.month = :month")
    List<MonthUserRole> findByMonthWithUsers(@NonNull @Param("month") Month month);
}
