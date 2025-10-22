import XCTest
@testable import DailyTips

final class DailyTipsTests: XCTestCase {

    @MainActor
    func testTotalWithoutRoundUp() {
        let vm = TipViewModel()
        vm.billAmount = "100"
        vm.tipPercent = 10
        vm.partySize = 1
        vm.roundUp = false
        XCTAssertEqual(vm.total, 110, accuracy: 0.001)
        XCTAssertEqual(vm.perPerson, 110, accuracy: 0.001)
    }

    @MainActor
    func testTotalWithRoundUp() {
        let vm = TipViewModel()
        vm.billAmount = "101.01"
        vm.tipPercent = 15   // 15.1515 → total 116.1615 → ceil = 117
        vm.partySize = 1
        vm.roundUp = true
        XCTAssertEqual(vm.total, 117, accuracy: 0.001)
    }

    @MainActor
    func testPerPersonSplit() {
        let vm = TipViewModel()
        vm.billAmount = "200"
        vm.tipPercent = 20   // total 240
        vm.partySize = 3
        vm.roundUp = false
        XCTAssertEqual(vm.perPerson, 80, accuracy: 0.001)
    }

    @MainActor
    func testNormalizeAmountInput() {
        let vm = TipViewModel()
        vm.normalizeAmountInput("00012.3.4")
        XCTAssertEqual(vm.billAmount, "12.34")
    }
}
