//
//  Project.swift
//  Manifests
//
//  Created by 문종식 on 1/18/26.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Module.Feature.vote.project(
    dependencies: [
        Module.core.toDependency,
        Module.domain.toDependency,
        Module.designSystem.toDependency,
        Module.Feature.auth.toDependency,
    ],
    infoPlist: .extendingDefault(
        with: [
            "NSPhotoLibraryAddUsageDescription":
                "투표 등록 시 사진을 등록하기 위해서 앨범 접근 권한이 필요합니다.",
            "NSPhotoLibraryUsageDescription":
                "투표 등록 시 사진을 등록하기 위해서 앨범 접근 권한이 필요합니다.",
        ]
    ),
)
