//
//  Module.swift
//  Manifests
//
//  Created by 문종식 on 1/20/26.
//

enum Module {
    /// 앱 최종 실행 모듈 (Main App)
    case app
    
    /// 전역 유틸리티 및 공통 모듈 프로젝트
    case core
    
    /// 디자인 시스템 프로젝트
    case designSystem
    
    /// 순수 비즈니스 로직 (CoreData Entities, Protocols)
    case domain
    
    /// 네트워크, DB 등 외부 데이터 서비스 프로젝트
    case service
    
    /// 각 기능 모듈 (Feature 기반 분리)
    case feature(Feature)
    

    enum Feature {
        /// 로그인
        case login
    }
}

