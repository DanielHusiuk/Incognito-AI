//
//  ApiManager.swift
//  Incognito AI
//
//  Created by Daniel Husiuk on 19.09.2025.
//

import Foundation

struct ChatMessage: Codable {
    let role: String
    var content: String
}

struct ChatChoice: Codable {
    let index: Int
    let finishReason: String
    let message: ChatMessage
}

struct ChatResponse: Codable {
    let id: String
    let object: String
    let model: String
    let choices: [ChatChoice]
}

struct ChatRequest: Codable {
    let model: String
    let messages: [ChatMessage]
}

class ApiManager {
    
    let url = URL(string: "https://models.github.ai/inference/chat/completions")
    var token: String = ""
    let modelString = UserDefaults.standard.string(forKey: "buttonModel") ?? "error"
    let messagesCollectionView = MessagesCollectionView()
    
    var userMessage: String = ""
    var finalResponse: String? = ""
    var requestBody: ChatRequest?
    
    func sendData() {
        if !userMessage.isEmpty {
            requestBody = ChatRequest(
                model: modelString,
                messages: [
                    ChatMessage(role: "system", content: """
                    You are an AI assistant operating within "Incognito AI," a privacy-first chat application natively built for iOS, and also available on iPadOS/macOS.
                                
                                CORE PRINCIPLES & PRIVACY:
                                - Full Incognito Mode: The user has no account, pays no subscription, and there is absolutely zero chat history saved.
                                - Never ask the user to "log in," "manage their account," as no historical data is retained. Treat every interaction as a fresh, secure session, but remember context of previous messages.
                    
                                RESPONSE TONE & QUALITY:
                                - Your responses must always be correct, fact-checked, professional, and clever.
                                - Base your answers strictly on scientific facts and established truths.
                                - Because the user has limited requests, your responses must be highly concise, direct, and immediately valuable. Avoid unnecessary fluff, long preambles, or filler text.
                    
                                APP CONTEXT & MULTI-MODEL CAPABILITY:
                                - You are one of five models available to the user in this app, provided for free via the GitHub AI Model Marketplace.
                                - The available lineup includes: OpenAI GPT-4o-mini, OpenAI GPT-4.1-mini, Meta Llama 4 Scout 17B, X Grok 3 Mini, and DeepSeek V3-0324.
                    
                                CAPABILITIES & LIMITATIONS:
                                - Currently, Incognito AI is strictly a text-based chat platform. You cannot process, view, or generate images, photos, videos, or voice audio.
                                - You support rich markdown formatting (bold, italics, headers, lists). 
                                - CRITICAL: Apply markdown directly to your text. NEVER wrap your overall response or text examples in ```markdown code blocks. Only use code blocks for actual programming languages (like Swift, Python, etc).
                                - If a user attempts to use multimedia features, politely inform them that Incognito AI is currently text-only, but that features like photos and voice may arrive in future updates.
                    
                                RATE LIMITS & USAGE:
                                The models in this app are powered by GitHub's free API usage. If a user asks about limits, explain that limits are set by GitHub to manage free access and are based on requests per minute, requests per day, and concurrent requests. If they hit a limit, they simply need to wait for it to reset.
                    
                                The specific Copilot Free daily limits for the models in this app are:
                                - OpenAI Models (Low Tier): 150 requests per day (15 req/min, 5 concurrent).
                                - Meta Llama Models (High Tier): 50 requests per day (10 req/min, 2 concurrent).
                                - DeepSeek Models: 50 requests per day (Note: GitHub base limits typically restrict DeepSeek to 8/day, but app allocation allows 50).
                                - X Grok 3 Mini: 30 requests per day (2 req/min, 1 concurrent).
                                - Token Limits: Most models allow up to 8,000 input tokens and 4,000 to 8,000 output tokens per request.
                    """),
                    ChatMessage(role: "user", content: userMessage),
                ]
            )
        }
    }
    
    func loadData(completion: @escaping (String?, String?) -> Void) {
        do {
            let jsonData = try JSONEncoder().encode(requestBody)
            var request = URLRequest(url: url!)
            request.httpMethod = "POST"
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/vnd.github+json", forHTTPHeaderField: "Accept")
            request.httpBody = jsonData
            
            let dataTask = URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let error = error {
                    DispatchQueue.main.async {
                        completion(nil, "Network error: \(error.localizedDescription)")
                    }
                    return
                }
                
                guard let data = data else {
                    DispatchQueue.main.async {
                        completion(nil, "No data received")
                    }
                    return
                }
                
                if let body = String(data: data, encoding: .utf8) {
                    print("Response body:", body)
                }
                
                if let httpResponse = response as? HTTPURLResponse {
                    print("Status code:", httpResponse.statusCode)
                }
                
                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    let chatResponse = try decoder.decode(ChatResponse.self, from: data)
                    let assistantMessage = chatResponse.choices.first?.message.content ?? ""
                    
                    print("Assistant says:", assistantMessage)
                    self.finalResponse = assistantMessage
                    DispatchQueue.main.async {
                        completion(assistantMessage, nil)
                    }
                } catch {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 5.0, execute: {
                        if let httpResponse = response as? HTTPURLResponse, let body = String(data: data, encoding: .utf8) {
                            completion(nil, "Status code:\(httpResponse.statusCode)\nResponse body:\(body)\n\(error.localizedDescription)")
                        } else {
                            completion(nil, "\(error.localizedDescription)")
                        }
                    })
                }
            }
            
            dataTask.resume()
        } catch {
            DispatchQueue.main.async {
                completion(nil, "Decoding error: \(error.localizedDescription)")
            }
        }
    }
    
}
