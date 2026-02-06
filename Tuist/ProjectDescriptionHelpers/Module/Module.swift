//
//  Module.swift
//  Manifests
//
//  Created by 문종식 on 1/20/26.
//

import ProjectDescription

// MARK: - Project Module (확장성 확보)
public enum Module: String, CaseIterable {
    /// 앱 최종 실행 모듈 (Main App)
    case app = "App"
    
    /// 전역 유틸리티 및 공통 모듈 프로젝트
    case core = "Core"
    
    /// 디자인 시스템 프로젝트
    case designSystem = "DesignSystem"
    
    /// 순수 비즈니스 로직 (CoreData Entities, Protocols)
    case domain = "Domain"
    
    /// 네트워크, DB 등 외부 데이터 서비스 프로젝트
    case service = "Service"
    
    /// 각 기능 모듈 (Feature 기반 분리)
    public enum Feature: String, CaseIterable {
        /// 로그인
        case login = "Login"
        
        /// 투표 생성
        case createVote = "CreateVote"
        
        /// 마이페이지
        case myPage = "MyPage"
    }
}
