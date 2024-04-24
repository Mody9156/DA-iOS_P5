//
//  tokenStore.swift
//  Aura
//
//  Created by KEITA on 24/04/2024.
//

import Foundation

protocol TokenStore {
    func insert(_ data: Data) throws
    func retrieve() throws -> Data
    func delete() throws
}
