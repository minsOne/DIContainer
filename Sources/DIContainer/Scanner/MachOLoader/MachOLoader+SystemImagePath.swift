//
//  MachOLoader+SystemImagePath.swift
//  DIContainer
//
//  Created by minsOne on 1/8/25.
//

extension MachOLoader {
    func isSystemImage(_ imageName: String) -> Bool {
        let systemImagePaths: [String] = [
            "/Library/Developer/CoreSimulator",
            "/Developer/Library",
            "/usr/lib",
        ]

        // 시스템 이미지 경로가 포함되는지 검사
        return systemImagePaths.contains { imageName.contains($0) }
    }
}
