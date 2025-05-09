# ScrollOffsetReader

A SwiftUI & Combine powered scroll-offset sampling component that lets you monitor `ScrollView` offsets smoothly and efficiently by sampling at intervals and filtering out insignificant changes.

## Features

* **Timed Sampling**
  Sample the latest offset at regular intervals (default 0.25s), avoiding excessive updates every frame.
* **Minimum-Difference Filtering**
  Only trigger updates when offset changes exceed a threshold (default 2.0pt), cutting down jitter noise.
* **Background ↔ Main Dispatch**
  Perform sampling on a background queue and publish on the main thread for safe, smooth UI updates.
* **Configurable**
  Customize sampling interval (`sampleInterval`) and minimum-difference threshold (`minDifference`).
* **Axes & Indicators**
  Monitor horizontal, vertical, or both axes, and choose whether to show scroll indicators.

## Installation

### Swift Package Manager

1. In Xcode, select **File → Swift Packages → Add Package Dependency...**
2. Enter the repository URL, for example:

   ```text
   https://github.com/<your-username>/ScrollOffsetReader.git
   ```
3. Specify a version range (e.g. `from: "1.0.0"`).

## Quick Start

```swift
import SwiftUI
import ScrollOffsetReader

struct ContentView: View {
    @State private var offset: CGSize = .zero

    var body: some View {
        VStack {
            Text("Offset: x=\(offset.width, specifier: "%.1f"), y=\(offset.height, specifier: "%.1f")")
                .padding()

            ScrollOffsetReader(
                scrollOffset: $offset,
                axes: .vertical,
                showsIndicators: false,
                sampleInterval: 0.2,   // Default 0.25
                minDifference: 1.0     // Default 2.0
            ) {
                LazyVStack {
                    ForEach(0..<100) { i in
                        Text("Item \(i)")
                            .frame(height: 50)
                    }
                }
            }
        }
    }
}
```

## API Reference

| Parameter         | Type              | Default     | Description                                                          |
| ----------------- | ----------------- | ----------- | -------------------------------------------------------------------- |
| `scrollOffset`    | `Binding<CGSize>` | —           | Binding to receive the sampled scroll offset                         |
| `axes`            | `Axis.Set`        | `.vertical` | Which axis (or axes) to monitor: `.horizontal`, `.vertical`, or both |
| `showsIndicators` | `Bool`            | `true`      | Whether to show scroll indicators                                    |
| `sampleInterval`  | `TimeInterval`    | `0.25`      | Sampling interval in seconds                                         |
| `minDifference`   | `CGFloat`         | `2.0`       | Minimum offset change (in points) required to trigger update         |

## How It Works

1. **OffsetSampler**

   * Uses a `CurrentValueSubject<CGSize, Never>` to accept raw offsets.
   * Applies a custom `sample(with:)` extension to combine offsets with a timer, taking only the latest value when the timer fires.
   * Removes duplicate values and publishes on the main thread via `@Published var sampledOffset`.
2. **ScrollOffsetModifier**

   * Holds `OffsetSampler` as a `@StateObject`.
   * Captures per-frame offsets via a `PreferenceKey` and forwards them to `sampler.update(offset:)`.
   * Listens to `sampler.$sampledOffset` and writes sampled values back to the bound `scrollOffset`.
3. **ScrollOffsetReader**

   * Wraps a `ScrollView`, `ZStack`, `ScrollOffsetProxy`, and `ScrollOffsetModifier` into one reusable component for one-line integration.

## Compatibility

* **Swift**: 5.9+
* **iOS**: 13.0+
* **macOS**: 11.0+
* **Xcode**: 15.0+

## License

MIT © Royal

---

# ScrollOffsetReader (中文)

基于 SwiftUI & Combine 的滚动偏移采样组件，帮助你在 `ScrollView` 中高效、平滑地监听滚动位置，并自动过滤无意义的小幅度抖动。

## 特性

* **定时采样**
  每隔指定时间间隔（默认 0.25s）采样最新偏移，避免在每帧都更新导致的性能问题。
* **最小差值过滤**
  仅当偏移变化超过阈值（默认 2.0pt）时才触发，减少抖动噪声。
* **后台 ↔ 主线程调度**
  在后台队列中采样，主线程上发布，确保 UI 更新安全且不卡顿。
* **可定制**
  自定义采样间隔（`sampleInterval`）和最小差值阈值（`minDifference`）。
* **多轴 & 滚动条**
  支持监测水平、垂直或双轴滚动，并可选择性显示或隐藏滚动条。

## 安装

### Swift Package Manager

1. 在 Xcode 中选择 **File → Swift Packages → Add Package Dependency...**
2. 输入仓库地址，例如：

   ```text
   https://github.com/<your-username>/ScrollOffsetReader.git
   ```
3. 指定版本区间（例如 `from: "1.0.0"`）。

## 快速开始

```swift
import SwiftUI
import ScrollOffsetReader

struct ContentView: View {
    @State private var offset: CGSize = .zero

    var body: some View {
        VStack {
            Text("偏移: x=\(offset.width, specifier: "%.1f"), y=\(offset.height, specifier: "%.1f")")
                .padding()

            ScrollOffsetReader(
                scrollOffset: $offset,
                axes: .vertical,
                showsIndicators: false,
                sampleInterval: 0.2,   // 默认 0.25
                minDifference: 1.0     // 默认 2.0
            ) {
                LazyVStack {
                    ForEach(0..<100) { i in
                        Text("Item \(i)")
                            .frame(height: 50)
                    }
                }
            }
        }
    }
}
```

## API 说明

| 参数                | 类型                | 默认值         | 说明                                     |
| ----------------- | ----------------- | ----------- | -------------------------------------- |
| `scrollOffset`    | `Binding<CGSize>` | —           | 绑定外部状态，用于接收采样后的滚动偏移                    |
| `axes`            | `Axis.Set`        | `.vertical` | 要监测的滚动方向：`.horizontal`、`.vertical` 或两者 |
| `showsIndicators` | `Bool`            | `true`      | 是否显示滚动条                                |
| `sampleInterval`  | `TimeInterval`    | `0.25`      | 采样间隔（秒）                                |
| `minDifference`   | `CGFloat`         | `2.0`       | 触发更新所需的最小偏移变化（pt）                      |

## 原理

1. **OffsetSampler**

   * 使用 `CurrentValueSubject<CGSize, Never>` 接收原始偏移；
   * 自定义 `sample(with:)` 将偏移与定时器结合，仅在定时器触发时取最新值；
   * 去重并在主线程通过 `@Published var sampledOffset` 发布。

2. **ScrollOffsetModifier**

   * 将 `OffsetSampler` 以 `@StateObject` 持有；
   * 通过 `PreferenceKey` 捕获每帧偏移并调用 `update(offset:)`；
   * 监听 `sampler.$sampledOffset`，将采样结果写回绑定的 `scrollOffset`。

3. **ScrollOffsetReader**

   * 封装 `ScrollView` + `ZStack` + `ScrollOffsetProxy` + `ScrollOffsetModifier`，一行代码即可使用。

## 兼容性

* **Swift**: 5.9+
* **iOS**: 13.0+
* **macOS**: 11.0+
* **Xcode**: 15.0+

## 许可证

MIT © Royal
