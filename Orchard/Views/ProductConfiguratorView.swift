//
//  ProductSelectorView.swift
//  Orchard
//
//  Created by John Behnke on 4/15/22.
//
import SwiftUI

struct Test: Identifiable {
  var id = UUID().uuidString
  var name: String
  init(name: String) {
    self.name = name
  }
}

struct ProductConfiguratorView: View {
  @State var selection: Int?
  @Environment(\.presentationMode) var presentationMode
  let tests: [Test] = [
    Test(name: "Macbook Air"),
    Test(name: "Macbook Pro 13\""),
    Test(name: "Macbook Pro 14\""),
    Test(name: "Macbook Pro 16\"")
  ]
  var body: some View {
    NavigationView {
      List(tests, id: \.id, selection: $selection) { item in
        NavigationLink(tag: item.id.hashValue, selection: $selection, destination: {
          ScrollView {
            VStack(alignment: .leading) {
              Text(item.name)
                .font(.title)
                .padding(.bottom)
              ColorSection()
                .padding()
              CPUSelection()
                .padding()
              MemorySelection()
                .padding()
              DiskSelection()
                .padding()
            }
            .padding()
          }
          HStack {
            Spacer()
            Button(action: {
              self.presentationMode.wrappedValue.dismiss()
            }, label: {Text("Cancel")}).keyboardShortcut(.cancelAction)
            Button(action: {
            }, label: {
              Text("Add")
            }).keyboardShortcut(.defaultAction)
          }
          .padding(10)
        }, label: {
          HStack {
            Image(systemName: "laptopcomputer")
            Text(item.name)
          }
          .font(.title2)
          .padding()
        })
      }
      .frame(minWidth: 250)
    }
    .onAppear {
      self.selection = tests[0].id.hashValue
    }
    .padding([.leading, .bottom, .top])
    .frame(width: 750, height: 500, alignment: .topLeading)
    .listStyle(.inset(alternatesRowBackgrounds: true))
  }
}

struct ProductSelectorView_Previews: PreviewProvider {
  static var previews: some View {
    ProductConfiguratorView()
  }
}

struct ColorSection: View {
  @State var colorSelection: Int = 0
  var imacColors: [(Color, Color)] = [
    (Color.imacBluePrimary, Color.imacBlueSecondary),
    (Color.imacGreenPrimary, Color.imacGreenSecondary),
    (Color.imacPinkPrimary, Color.imacPinkSecondary),
    (Color.imacYellowPrimary, Color.imacYellowSecondary),
    (Color.imacOrangePrimary, Color.imacOrangeSecondary),
    (Color.imacPurplePrimary, Color.imacPurpleSecondary)
  ]
  var body: some View {
    VStack(alignment: .leading) {
      HStack {
        Image(systemName: "paintpalette")
        Text("Color")
      }.font(.title2)
      HStack {
        VStack(alignment: .leading) {
          Text(colorSelection == 0
               ? "Space Gray"
               : colorSelection == 1
               ? "Gold"
               :"Silver").font(.subheadline).padding(.top, 2)
          HStack {
            ForEach(Array(zip(imacColors, imacColors.indices)), id: \.0.0.hashValue) { color, index in
              Circle().dualToneFill(left: color.0, right: color.1)
                .selectable(
                  selection: $colorSelection,
                  tag: index,
                  shape: AnyShape(Circle()),
                  strokeTint: .accentColor,
                  stokeWidth: 2
                )
            }
          }
        }
      }
    }
  }
}

struct CPUSelection: View {
  @State var cpuSelection: Int = 0
  var cpuConfigurations = ["M1 8-Core CPU and 7-Core GPU", "M1 8-Core CPU and 8-Core GPU"]
  var body: some View {
    VStack(alignment: .leading) {
      HStack {
        Image(systemName: "cpu")
        Text("System on a Chip (Processor)")
      }.font(.title2)
      LazyVGrid(columns: [
        GridItem(.flexible()),
        GridItem(.flexible())
      ]) {
        ForEach(Array(zip(cpuConfigurations, cpuConfigurations.indices)), id: \.1) { config, index in
          Text(config)
            .frame(width: 160)
            .padding().background(RoundedRectangle(cornerRadius: 5).foregroundColor(.secondary).opacity(0.1))
            .selectable(
              selection: $cpuSelection,
              tag: index,
              shape: AnyShape(RoundedRectangle(cornerRadius: 5)),
              strokeTint: .accentColor,
              stokeWidth: 2
            )
        }
      }
    }
  }
}

struct MemorySelection: View {
  @State var memSelection: Int = 0
  var ramConfigurations = ["8", "16", "32", "64", "128"]
  var body: some View {
    VStack(alignment: .leading) {
      HStack {
        Image(systemName: "memorychip")
        Text("Memory")
      }.font(.title2)
      LazyVGrid(columns: [
        GridItem(.flexible()),
        GridItem(.flexible())
      ]) {
        ForEach(Array(zip(ramConfigurations, ramConfigurations.indices)), id: \.1) { config, index in
          Text("\(config)GB unified memory")
            .frame(width: 160)
            .padding().background(RoundedRectangle(cornerRadius: 5).foregroundColor(.secondary).opacity(0.1))
            .selectable(
              selection: $memSelection,
              tag: index,
              shape: AnyShape(RoundedRectangle(cornerRadius: 5)),
              strokeTint: .accentColor,
              stokeWidth: 2
            )
        }
      }
    }
  }
}

struct DiskSelection: View {
  @State var driveSelection: Int = 0
  var diskConfigurations = ["256GB", "512GB", "1TB", "2TB", "4TB", "8TB"]
  var body: some View {
    VStack(alignment: .leading) {
      HStack {
        Image(systemName: "internaldrive")
        Text("Storage")
      }.font(.title2)
      LazyVGrid(columns: [
        GridItem(.flexible(minimum: 40), spacing: 20),
        GridItem(.flexible(minimum: 40), spacing: 20)
      ]) {
        ForEach(Array(zip(diskConfigurations, diskConfigurations.indices)), id: \.1) { config, index in
          Text("\(config) SSD")
            .frame(width: 160)
            .padding().background(RoundedRectangle(cornerRadius: 5).foregroundColor(.secondary).opacity(0.1))
            .selectable(
              selection: $driveSelection,
              tag: index,
              shape: AnyShape(RoundedRectangle(cornerRadius: 5)),
              strokeTint: .accentColor,
              stokeWidth: 2)
        }
      }
    }
  }
}
