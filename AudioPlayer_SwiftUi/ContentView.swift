//
//  ContentView.swift
//  AudioPlayer_SwiftUi
//
//  Created by Arjunan on 26/03/24.
//

import SwiftUI
import AVFoundation
import UIKit

struct GuidedMeditationView: View {
    @State private var audioPlayer: AVPlayer?
    @State private var isPlaying: Bool = false
    @State private var storedTime: CMTime = .zero
    @State private var progress: Double = 0.0
    @State private var timer: Timer?
    
    var body: some View {
        VStack {
            HStack {
                Button(action: { self.play() }) {
                    Image(systemName: "play.square.fill")
                        .font(.system(size: 50.0))
                }

                Button(action: { self.pause() }) {
                    Image(systemName: "pause.rectangle.fill")
                        .font(.system(size: 50.0))
                }

                Button(action: { self.stop() }) {
                    Image(systemName: "xmark.square.fill")
                        .font(.system(size: 50.0))
                }
            }
            
            ProgressView("Progress:", value: progress, total: 1.0)
                .frame(width: 200, height: 20)
        }
    }

    func play() {
        guard let fileURL = URL(string: "https://codeskulptor-demos.commondatastorage.googleapis.com/pang/paza-moduless.mp3") else {
            print("Error finding audio file")
            return
        }

        do {
            let playerItem = AVPlayerItem(url: fileURL)
            audioPlayer = AVPlayer(playerItem: playerItem)
            audioPlayer?.seek(to: storedTime)
            audioPlayer?.play()
            isPlaying = true
            timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
                self.updateProgress()
            }
        } catch {
            print("Error playing audio: \(error)")
        }
    }

    func pause() {
        audioPlayer?.pause()
        isPlaying = false
        storedTime = audioPlayer?.currentTime() ?? .zero
        timer?.invalidate()
    }

    func stop() {
        audioPlayer?.pause()
        audioPlayer?.seek(to: .zero)
        isPlaying = false
        storedTime = .zero
        progress = 0.0
        timer?.invalidate()
    }

    func updateProgress() {
        guard let audioPlayer = audioPlayer else { return }
        let currentTime = audioPlayer.currentTime()
        let duration = audioPlayer.currentItem?.duration ?? .zero
        progress = CMTimeGetSeconds(currentTime) / CMTimeGetSeconds(duration)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        GuidedMeditationView()
    }
}



#Preview {
    GuidedMeditationView()
}
