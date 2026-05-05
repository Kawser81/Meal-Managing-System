package com.mealmanager.repository;

import com.mealmanager.model.ChatMessage;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface ChatMessageRepository extends JpaRepository<ChatMessage, Long> {
    List<ChatMessage> findAllByOrderBySentAtAsc();
    List<ChatMessage> findByIdGreaterThanOrderBySentAtAsc(Long lastId);
}