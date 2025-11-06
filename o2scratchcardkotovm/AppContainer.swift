//
//  AppContainer.swift
//  o2scratchcardkotovm
//
//  Created by Mykhailo Kotov on 04/11/2025.
//

import CoreDomain
import DataLayer

final class AppContainer {
  let repo = ScratchCardRepositoryImpl()
  lazy var observe = GetStateScratchCardUseCase(repo: repo)
  lazy var generate = GetCodeScratchCardUseCase(repo: repo)
  lazy var activate = ActivateCodeScratchCardUseCase(repository: repo, api: APIClient())
}
