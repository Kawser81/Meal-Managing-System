package com.mealmanager.service;

import com.mealmanager.model.*;
import com.mealmanager.repository.DepositRepository;
import org.springframework.stereotype.Service;

import java.util.*;

@Service
public class DepositService {

    private final DepositRepository depositRepository;
    private final MonthService monthService;
    private final MonthUserRoleService roleService;

    public DepositService(DepositRepository depositRepository,
                          MonthService monthService,
                          MonthUserRoleService roleService) {
        this.depositRepository = depositRepository;
        this.monthService = monthService;
        this.roleService = roleService;
    }

    public Month getActiveMonth() {
        return monthService.getActiveMonth();
    }

    public boolean isManager(User user, Month month) {
        return roleService.isManager(user, month);
    }

    public List<Deposit> getDepositsByMonth(Month month) {
        return depositRepository.findByMonth(month);
    }

    public List<Deposit> getDepositsForUser(User user, Month month) {
        return depositRepository.findByUserAndMonth(user, month);
    }

    public int getTotalForUser(User user, Month month) {
        return depositRepository.findByUserAndMonth(user, month)
                .stream()
                .mapToInt(Deposit::getAmount)
                .sum();
    }

    public void addDeposit(User user, Month month, int amount, String note) {
        Deposit deposit = new Deposit();
        deposit.setUser(user);
        deposit.setMonth(month);
        deposit.setAmount(amount);
        deposit.setNote(note);
        depositRepository.save(deposit);
    }

    public void delete(Long id) {
        depositRepository.deleteById(id);
    }

    public Map<Long, List<Deposit>> buildDepositMap(Month month) {
        List<Deposit> all = depositRepository.findByMonth(month);
        Map<Long, List<Deposit>> map = new LinkedHashMap<>();
        for (Deposit d : all) {
            Long uid = d.getUser().getId();
            map.computeIfAbsent(uid, k -> new ArrayList<>()).add(d);
        }
        return map;
    }

    public Map<Long, Integer> buildTotalMap(Month month) {
        List<Deposit> all = depositRepository.findByMonth(month);
        Map<Long, Integer> map = new HashMap<>();
        for (Deposit d : all) {
            Long uid = d.getUser().getId();
            map.merge(uid, d.getAmount(), Integer::sum);
        }
        return map;
    }
}