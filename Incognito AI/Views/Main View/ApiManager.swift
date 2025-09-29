//
//  ApiManager.swift
//  Incognito AI
//
//  Created by Daniel Husiuk on 19.09.2025.
//

import Foundation

struct ChatMessage: Codable {
    let role: String
    let content: String
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
    
    var userMessage: String = ""
    var finalResponse: String = ""
    var requestBody: ChatRequest?

    func sendData() {
        if !userMessage.isEmpty {
            var requestBody = ChatRequest(
                model: "openai/gpt-4.1-mini",
                messages: [
                    ChatMessage(role: "system", content: "You are a helpful assistant in Incognito AI app."),
                    ChatMessage(role: "user", content: userMessage),
                ]
            )
        }
    }



    func loadData() {
        do {
            guard let requestBody else { return }
            let jsonData = try JSONEncoder().encode(requestBody)
            var request = URLRequest(url: url!)
            request.httpMethod = "POST"
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/vnd.github+json", forHTTPHeaderField: "Accept")
            request.httpBody = jsonData
            
            let dataTask = URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                
                if let data = data,
                    let body = String(data: data, encoding: .utf8) {
                        print("Response body:", body)
                    }
                
                if let httpResponse = response as? HTTPURLResponse {
                    print("Status code:", httpResponse.statusCode)
                    
                }
                
                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    let chatResponse = try decoder.decode(ChatResponse.self, from: data!)
                    let assistantMessage = chatResponse.choices.first?.message.content ?? ""
                    
                    print("Assistant says:", assistantMessage)
                    self.finalResponse = assistantMessage
                } catch {
                    print(error.localizedDescription)
                }
            }
            dataTask.resume()
        } catch {
            print(error.localizedDescription)
        }
    }
    
}
