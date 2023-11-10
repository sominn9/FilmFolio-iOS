//
//  Inject.swift
//  FilmFolio
//
//  Created by 신소민 on 10/30/23.
//

import Foundation

@propertyWrapper
class Inject<T> {
    private var dependency: T?
    private let resolve: () -> T
    
    var wrappedValue: T {
        dependency ?? {
            let object = resolve()
            self.dependency = object
            return object
        }()
    }
    
    init() {
        resolve = {
            return DIContainer.shared.resolve()
        }
    }
    
    init(name: String?) {
        resolve = {
            return DIContainer.shared.resolve(name: name)
        }
    }
    
    init<Arg>(argument: Arg) {
        resolve = {
            return DIContainer.shared.resolve(argument: argument)
        }
    }
    
    init<Arg1, Arg2>(arguments arg1: Arg1, _ arg2: Arg2) {
        resolve = {
            return DIContainer.shared.resolve(arguments: arg1, arg2)
        }
    }
}
