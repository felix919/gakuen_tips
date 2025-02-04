//
//  NIAScoreDetailView.swift
//  Gakuen_tips
//
//

import SwiftUI


final class NIAScoreViewState: ObservableObject {
    @Published var stages: [StageParameter] = []
    
    var vocalTotalScore = 0
    var danceTotalScore = 0
    var visualTotalScore = 0
    
    init(stagesCount: Int) {
        // 最終ターンの合計も含めるため、＋１する
        self.stages = Array(repeating: StageParameter(), count: stagesCount + 1)
        
        for i in 0..<stages.count {
            stages[i].remainTurn = stagesCount - i
        }
        
    }
    
    // 最終3ターンのパラメータを固定する
    func setLastStageParameterType(
        first: ParameterType,
        second: ParameterType,
        third: ParameterType
    ) {
        // 最終3ターンは得意ステータスから固定する
        let lastTurn = stages.count - 1 - 1
        stages[lastTurn].parameterType = first
        stages[lastTurn - 1].parameterType = second
        stages[lastTurn - 2].parameterType = third
    }
    
    // 獲得スコアを更新する
    func updateScore(remainTurn: Int, score: Int) {
        // 入力されたステージを取得する
        guard let stageIndex = stages.firstIndex(where: { $0.remainTurn  == remainTurn}) else {
            return
        }
        
        // ステージに合計点を入力する
        stages[stageIndex].startScore = score
        
        updateTotalScore()
    }
    
    func updateParameter(remainTurn: Int, parameter: ParameterType) {
        // 入力されたステージを取得する
        guard let stageIndex = stages.firstIndex(where: { $0.remainTurn  == remainTurn}) else {
            return
        }
        
        stages[stageIndex].parameterType = parameter
        
        updateTotalScore()
    }
    
    // 合計点を更新する
    private func updateTotalScore() {
        vocalTotalScore = 0
        danceTotalScore = 0
        visualTotalScore = 0
        for i in 1..<stages.count - 1 {
            // パラメータの点数を計算する
            let score = stages[i].startScore - stages[i - 1].startScore
            if score < 0 {
                continue
            }
            switch stages[i].parameterType {
            case .VOCAL:
                stages[i].vocalScore = score
                stages[i].danceScore = 0
                stages[i].visualScore = 0
            case .DANCE:
                stages[i].vocalScore = 0
                stages[i].danceScore = score
                stages[i].visualScore = 0
            case .VISUAL:
                stages[i].vocalScore = 0
                stages[i].danceScore = 0
                stages[i].visualScore = score
            }
            
            // 合計点を計算する
            vocalTotalScore += stages[i].vocalScore
            danceTotalScore += stages[i].danceScore
            visualTotalScore += stages[i].visualScore
        }
        
    }
}

struct StageParameter: Hashable {
    var remainTurn = 0
    var parameterType = ParameterType.VOCAL
    var startScore = 0
    
    var vocalScore = 0
    var danceScore = 0
    var visualScore = 0
}

struct NIAScoreDetailView: View {
    // 得意ステータス
    var first: ParameterType
    var second: ParameterType
    var third: ParameterType
    
    // ステージごとのスコア
    @ObservedObject var viewState = NIAScoreViewState(stagesCount: 12)
    
    @State private var inputParameters = Array(repeating: ParameterType.VOCAL, count: 12 + 1)
    @State private var inputScores = Array(repeating: 0, count: 12 + 1)
    
    init(first: ParameterType, second: ParameterType, third: ParameterType) {
        self.first = first
        self.second = second
        self.third = third

        self.viewState.setLastStageParameterType(
            first: first,
            second: second,
            third: third
        )
    }
    
    var body: some View {
        let bounds = UIScreen.main.bounds
        let width = Int(bounds.width)
                    
        VStack {
            // 第1上限
            Text("第1上限")
            Grid(alignment: .center, horizontalSpacing: 8.0) {
                GridRow {
                    Text(" ")
                    Text("累計")
                    Text("上限")
                    Text("残り")
                }
                GridRow {
                    Text("Vo")
                    Text("\(viewState.vocalTotalScore)")
                    Text("38,400")
                    Text("\(38400 - viewState.vocalTotalScore)")
                }
                .background(Color(.vocal))
                GridRow {
                    Text("Da")
                    Text("\(viewState.danceTotalScore)")
                    Text("31,800")
                    Text("\(31800 - viewState.danceTotalScore)")
                }
                .background(Color(.dance))
                GridRow {
                    Text("Vi")
                    Text("\(viewState.visualTotalScore)")
                    Text("26,000")
                    Text("\(26000 - viewState.visualTotalScore)")
                }
                .background(Color(.visual))
            }
            Divider()
            // 第2上限
            Text("第2上限")
            Grid(alignment: .center, horizontalSpacing: 8.0) {
                GridRow {
                    Text(" ")
                    Text("累計")
                    Text("上限")
                    Text("残り")
                }
                GridRow {
                    Text("Vo")
                    Text("\(viewState.vocalTotalScore)")
                    Text("80,000")
                    Text("\(80000 - viewState.vocalTotalScore)")
                }
                .background(Color(.vocal))
                GridRow {
                    Text("Da")
                    Text("\(viewState.danceTotalScore)")
                    Text("65,000")
                    Text("\(65000 - viewState.danceTotalScore)")
                }
                .background(Color(.dance))
                GridRow {
                    Text("Vi")
                    Text("\(viewState.visualTotalScore)")
                    Text("55,000")
                    Text("\(55000 - viewState.visualTotalScore)")
                }
                .background(Color(.visual))
            }
            Divider()
            // ステージ
            Text("ステージごとのパラメータを入力する")
            Grid(alignment: .center, horizontalSpacing: 8.0) {
                GridRow {
                    Text("残りターン")
                    Text("ステータス")
                    Text("開始スコア")
                }
                

                ForEach($viewState.stages, id: \.self) { stage in
                    let backgroundColor = stage.remainTurn.wrappedValue == 0 ?
                        Color(.clear) : stage.parameterType.wrappedValue.getColor()
                    
                    HStack(alignment: .center) {
                        Spacer()
                        // 残りターン
                        if stage.remainTurn.wrappedValue != 0 {
                            Text("\(stage.remainTurn.wrappedValue)")
                                .frame(width: CGFloat(Double(width) * 0.2))
                        } else {
                            Text("最終")
                                .frame(width: CGFloat(Double(width) * 0.2))
                        }
                        Spacer()
                        
                        // 得意ステータス
                        let inputParameter = $inputParameters[12 - stage.remainTurn.wrappedValue]
                        if stage.remainTurn.wrappedValue != 0 {
                            Picker(selection: inputParameter, label: Text("Select a paint color")) {
                                ForEach(ParameterType.allCases, id: \.self) {
                                    Text($0.rawValue)
                                }
                            }
                            .onChange(of: inputParameter.wrappedValue) {
                                // 得意ステータスを更新したら合計点を更新する
                                print("得意ステータス")
                                viewState.updateParameter(
                                    remainTurn: stage.remainTurn.wrappedValue,
                                    parameter: inputParameter.wrappedValue)
                            }
                            .pickerStyle(.menu)
                            .frame(width: CGFloat(Double(width) * 0.3), height:24)
                        } else {
                            Spacer()
                                .frame(width: CGFloat(Double(width) * 0.3), height:24)
                        }

                        Spacer()
                        
                        // 開始スコア
                        let inputScore = $inputScores[12 - stage.remainTurn.wrappedValue]
                        TextField("Int", value: inputScore, format: .number)
                            .onChange(of: inputScore.wrappedValue) {
                                // 開始スコアを更新したら合計点を更新する
                                print("開始スコア")
                                viewState.updateScore(
                                    remainTurn: stage.remainTurn.wrappedValue,
                                    score: inputScore.wrappedValue
                                )
                            }
                            .textFieldStyle(.roundedBorder)
                            .frame(width: CGFloat(Double(width) * 0.2))

                        Spacer()
                    }
                    .frame(width: CGFloat(Double(width) * 0.8), height: 24)
                    .background(content: {
                        backgroundColor
                                .edgesIgnoringSafeArea(.all)

                    })
                }
            }
        }
    }
}


#Preview {
    NIAScoreDetailView(
        first: .VOCAL, second: .DANCE, third: .VISUAL
    )
}
