package com.mealmanager.controller;

import com.mealmanager.model.ChatMessage;
import com.mealmanager.model.User;
import com.mealmanager.service.ChatService;
import com.mealmanager.service.UserService;
import jakarta.servlet.http.HttpSession;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Controller
@RequestMapping("/chat")
public class ChatController {

    private static final String VIEW_CHAT = "chat/chat-page";

    private final ChatService chatService;
    private final UserService userService;

    public ChatController(ChatService chatService, UserService userService) {
        this.chatService = chatService;
        this.userService = userService;
    }

    @GetMapping("")
    public String chatPage(Model model, HttpSession session) {
        User currentUser = resolveUser(session);

        model.addAttribute("currentUser", currentUser);
        model.addAttribute("messages",    chatService.getAllMessages());

        return VIEW_CHAT;
    }

    @PostMapping("/send")
    @ResponseBody
    public ResponseEntity<?> send(@RequestParam String message,
                                  HttpSession session) {
        if (message == null || message.trim().isEmpty()) {
            return ResponseEntity.badRequest().body("Empty message");
        }

        User currentUser = resolveUser(session);
        ChatMessage saved = chatService.send(currentUser, message);

        return ResponseEntity.ok(toMap(saved, currentUser));
    }

    @GetMapping("/poll")
    @ResponseBody
    public ResponseEntity<List<Map<String, Object>>> poll(
            @RequestParam(defaultValue = "0") Long lastId,
            HttpSession session) {

        User currentUser = resolveUser(session);
        List<ChatMessage> newMessages = chatService.getNewMessages(lastId);

        List<Map<String, Object>> result = newMessages.stream()
                .map(m -> toMap(m, currentUser))
                .collect(Collectors.toList());

        return ResponseEntity.ok(result);
    }

    private User resolveUser(HttpSession session) {
        String email = (String) session.getAttribute("loggedInUser");
        return userService.findByEmail(email);
    }

    private Map<String, Object> toMap(ChatMessage m, User currentUser) {
        return Map.of(
                "id",       m.getId(),
                "sender",   m.getUser().getName(),
                "message",  m.getMessage(),
                "sentAt",   m.getSentAt().toString().replace("T", " ").substring(0, 16),
                "isMine",   m.getUser().getId().equals(currentUser.getId())
        );
    }
}