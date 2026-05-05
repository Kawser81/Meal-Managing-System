package com.mealmanager.service;

import com.mealmanager.model.ChatMessage;
import com.mealmanager.model.User;
import com.mealmanager.repository.ChatMessageRepository;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.List;

@Service
public class ChatService {

    private final ChatMessageRepository chatMessageRepository;

    public ChatService(ChatMessageRepository chatMessageRepository) {
        this.chatMessageRepository = chatMessageRepository;
    }

    public List<ChatMessage> getAllMessages() {
        return chatMessageRepository.findAllByOrderBySentAtAsc();
    }

    public List<ChatMessage> getNewMessages(Long lastId) {
        return chatMessageRepository.findByIdGreaterThanOrderBySentAtAsc(lastId);
    }

    public ChatMessage send(User user, String message) {
        ChatMessage chatMessage = new ChatMessage();
        chatMessage.setUser(user);
        chatMessage.setMessage(message.trim());
        chatMessage.setSentAt(LocalDateTime.now());
        return chatMessageRepository.save(chatMessage);
    }
}