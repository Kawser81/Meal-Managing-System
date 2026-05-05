package com.mealmanager.controller;

import com.mealmanager.model.*;
import com.mealmanager.service.DepositService;
import com.mealmanager.service.UserService;
import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

@Controller
@RequestMapping("/deposit")
public class DepositController {

    private static final String VIEW_DEPOSIT = "deposit/deposit-page";
    private static final String VIEW_403 = "error/403";
    private static final String REDIRECT_DEPOSIT = "redirect:/deposit";

    private final DepositService depositService;
    private final UserService userService;

    public DepositController(DepositService depositService,
                             UserService userService) {
        this.depositService = depositService;
        this.userService = userService;
    }

    @GetMapping("")
    public String depositPage(Model model, HttpSession session) {
        User currentUser = resolveUser(session);
        Month month = depositService.getActiveMonth();

        if (month == null) {
            model.addAttribute("error", "No active month found.");
            return VIEW_DEPOSIT;
        }

        model.addAttribute("month",      month);
        model.addAttribute("users",      userService.getAllUsers());
        model.addAttribute("depositMap", depositService.buildDepositMap(month));
        model.addAttribute("totalMap",   depositService.buildTotalMap(month));
        model.addAttribute("isManager",  depositService.isManager(currentUser, month));

        return VIEW_DEPOSIT;
    }

    @PostMapping("/add")
    public String addDeposit(@RequestParam Long userId,
                             @RequestParam int amount,
                             @RequestParam(required = false) String note,
                             HttpSession session) {
        User currentUser = resolveUser(session);
        Month month = depositService.getActiveMonth();

        if (!depositService.isManager(currentUser, month)) return VIEW_403;

        User targetUser = userService.findById(userId);
        depositService.addDeposit(targetUser, month, amount, note);

        return REDIRECT_DEPOSIT;
    }

    @PostMapping("/delete")
    public String deleteDeposit(@RequestParam Long depositId,
                                HttpSession session) {
        User currentUser = resolveUser(session);
        Month month = depositService.getActiveMonth();

        if (!depositService.isManager(currentUser, month)) return VIEW_403;

        depositService.delete(depositId);

        return REDIRECT_DEPOSIT;
    }

    private User resolveUser(HttpSession session) {
        String email = (String) session.getAttribute("loggedInUser");
        return userService.findByEmail(email);
    }
}