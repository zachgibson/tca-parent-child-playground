//
//  ContentView.swift
//  TCA Parent Child Playground
//
//  Created by Zachary Gibson on 12/17/23.
//

import ComposableArchitecture
import SwiftUI

@Reducer
struct MainFeature {
    @ObservableState
    struct State {
        @Presents var destination: Destination.State?
    }
    enum Action: BindableAction {
        case binding(BindingAction<State>)
        case buttonTapped
        case destination(PresentationAction<Destination.Action>)
    }
    var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .binding:
                return .none
            case .buttonTapped:
                state.destination = .detailItem(DetailFeature.State())
                return .none
            case .destination(.presented(.detailItem(.dismissButtonTapped))):
                state.destination = nil
                return .none
            case .destination:
                return .none
            }
        }
        .ifLet(\.$destination, action: \.destination) {
            Destination()
        }
    }
    
    @Reducer
    struct Destination {
        enum State {
            case detailItem(DetailFeature.State)
        }
        enum Action {
            case detailItem(DetailFeature.Action)
        }
        var body: some ReducerOf<Self> {
            Scope(state: \.detailItem, action: \.detailItem) {
                DetailFeature()
            }
        }
    }
}

struct ContentView: View {
    @Bindable var store: StoreOf<MainFeature>
    var body: some View {
        VStack {
            Button("Present Child") {
                store.send(.buttonTapped)
            }
        }
        .padding()
        .fullScreenCover(
            item: $store.scope(
                state: \.destination?.detailItem,
                action: \.destination.detailItem
            )
        ) { store in
            DetailView(store: store)
        }
    }
}

@Reducer
struct DetailFeature {
    @ObservableState
    struct State {
        var intensity = 1.0
    }
    enum Action: BindableAction {
        case binding(BindingAction<State>)
        case dismissButtonTapped
        enum Delegate {
            case dismissButtonTapped
        }
    }
    var body: some Reducer<State, Action> {
        BindingReducer()
    }
}

struct DetailView: View {
    @Bindable var store: StoreOf<DetailFeature>
    var body: some View {
        NavigationStack {
            Slider(value: $store.intensity, in: 0...1)
                .padding()
                .navigationTitle("Child Feature")
                .toolbar {
                    ToolbarItem(placement: .primaryAction) {
                        Button("Dismiss") {
                            store.send(.dismissButtonTapped)
                        }
                    }
                }
        }
    }
}

#Preview {
    ContentView(store: Store(initialState: MainFeature.State()) {
        MainFeature()
    })
}
