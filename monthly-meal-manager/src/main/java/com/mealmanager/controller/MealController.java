package com.mealmanager.controller;

import com.mealmanager.model.*;
import com.mealmanager.service.MealService;
import com.mealmanager.service.UserService;
import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;

@Controller
@RequestMapping("/meal")
public class MealController {

    private static final String VIEW_MEAL_PAGE = "meal/meal-page";
    private static final String VIEW_403 = "error/403";
    private static final String REDIRECT_MEAL = "redirect:/meal";
    private final MealService mealService;
    private final UserService userService;

    public MealController(MealService mealService, UserService userService) {
        this.mealService = mealService;
        this.userService = userService;
    }

    @GetMapping("")
    public String mealPage(Model model, HttpSession session) {
        User currentUser = resolveUser(session);
        Month month = mealService.getActiveMonth();

        if (month == null) {
            model.addAttribute("error", "No active month found.");
            return VIEW_MEAL_PAGE;
        }

        model.addAttribute("month", month);
        model.addAttribute("dates", mealService.getDatesForMonth(month));
        model.addAttribute("users", userService.getAllUsers());
        model.addAttribute("mealMap", mealService.buildMealMap(month));
        model.addAttribute("currentUser", currentUser);
        model.addAttribute("isManager", mealService.isManager(currentUser, month));

        return VIEW_MEAL_PAGE;
    }

    @PostMapping("/save")
    public String saveMeal(@RequestParam Long userId,
                           @RequestParam String date,
                           @RequestParam int mealCount,
                           HttpSession session) {
        User currentUser = resolveUser(session);
        Month month = mealService.getActiveMonth();

        if (!mealService.isManager(currentUser, month)) return VIEW_403;

        User targetUser = userService.findById(userId);
        mealService.saveMeal(targetUser, month, LocalDate.parse(date), mealCount);

        return REDIRECT_MEAL;
    }

    @PostMapping("/delete")
    public String deleteMeal(@RequestParam Long mealId, HttpSession session) {
        User currentUser = resolveUser(session);
        Month month = mealService.getActiveMonth();

        if (!mealService.isManager(currentUser, month)) return VIEW_403;

        mealService.delete(mealId);
        return REDIRECT_MEAL;
    }

    private User resolveUser(HttpSession session) {
        String email = (String) session.getAttribute("loggedInUser");
        return userService.findByEmail(email);
    }
}