//
//  PollsViewModel.swift
//  VoicedApp
//
//  Created by Joanna Rodriguez on 4/8/24.
//

import Foundation
import Combine

class PollsViewModel: ObservableObject {
    @Published var polls: [Poll] = []
    private var cancellables = Set<AnyCancellable>()

    init() {
        fetchPolls()
    }

    func fetchPolls() {
        Task {
            do {
                let fetchedPolls = try await PollService.fetchPolls()
                DispatchQueue.main.async {
                    self.polls = fetchedPolls
                }
            } catch {
                print("Error fetching polls: \(error)")
            }
        }
    }
}
