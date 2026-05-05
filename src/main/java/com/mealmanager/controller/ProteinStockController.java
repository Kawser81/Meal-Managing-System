package com.mealmanager.controller;

import com.mealmanager.model.Month;
import com.mealmanager.model.ProteinStock;
import com.mealmanager.model.User;
import com.mealmanager.service.MonthService;
import com.mealmanager.service.MonthUserRoleService;
import com.mealmanager.service.ProteinStockService;
import com.mealmanager.service.UserService;
import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.List;

@Controller
@RequestMapping("/protein")
public class ProteinStockController {

    private static final String PROTEIN = "protein";
    private static final String REDIRECT_PROTEIN = "redirect:/protein";
    private static final String VIEW_403 = "error/403";

    private final ProteinStockService proteinStockService;
    private final MonthService monthService;
    private final UserService userService;
    private final MonthUserRoleService roleService;

    public ProteinStockController(
            ProteinStockService proteinStockService,
            MonthService monthService,
            UserService userService,
            MonthUserRoleService roleService) {
        this.proteinStockService = proteinStockService;
        this.monthService = monthService;
        this.userService = userService;
        this.roleService = roleService;
    }

    @GetMapping("")
    public String page(Model model, HttpSession session) {
        String email = (String) session.getAttribute("loggedInUser");
        User currentUser = userService.findByEmail(email);
        Month month = monthService.getActiveMonth();

        if (month == null) {
            model.addAttribute("error", "No active month found.");
            return PROTEIN;
        }

        List<ProteinStock> stocks = proteinStockService.getStocksByMonth(month);

        model.addAttribute("month", month);
        model.addAttribute("stocks", stocks);
        model.addAttribute("isManager", roleService.isManager(currentUser, month));

        return PROTEIN;
    }

    @PostMapping("/add")
    public String add(@RequestParam String itemName,
                      @RequestParam Integer quantity,
                      @RequestParam(required = false) String unit,
                      @RequestParam(required = false) String note,
                      HttpSession session) {

        User currentUser = userService.findByEmail(
                (String) session.getAttribute("loggedInUser"));
        Month month = monthService.getActiveMonth();

        if (!roleService.isManager(currentUser, month)) return VIEW_403;

        proteinStockService.addStock(month, itemName, quantity, unit, note);
        return REDIRECT_PROTEIN;
    }

    @PostMapping("/update")
    public String update(@RequestParam Long stockId,
                         @RequestParam Integer quantity,
                         @RequestParam(required = false) String unit,
                         @RequestParam(required = false) String note,
                         HttpSession session) {

        User currentUser = userService.findByEmail(
                (String) session.getAttribute("loggedInUser"));
        Month month = monthService.getActiveMonth();

        if (!roleService.isManager(currentUser, month)) return VIEW_403;

        proteinStockService.updateStock(stockId, quantity, unit, note);
        return REDIRECT_PROTEIN;
    }

    @PostMapping("/delete")
    public String delete(@RequestParam Long stockId, HttpSession session) {

        User currentUser = userService.findByEmail(
                (String) session.getAttribute("loggedInUser"));
        Month month = monthService.getActiveMonth();

        if (!roleService.isManager(currentUser, month)) return VIEW_403;

        proteinStockService.deleteStock(stockId);
        return REDIRECT_PROTEIN;
    }
}