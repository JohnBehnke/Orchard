//
//  ProductSelectorView.swift
//  Orchard
//
//  Created by John Behnke on 4/15/22.
//
import SwiftUI

struct ProductConfiguratorView: View {
  @State var productSelection: Int? = 0
  @State var optionSelection: Int = 0
  @Environment(\.presentationMode) var presentationMode
  @EnvironmentObject var userDataStore: UserDataStore
  @EnvironmentObject var products: ProductStore
  var body: some View {
    NavigationView {
      List(products.products.indices, id: \.self) { index in
        NavigationLink(tag: index, selection: $productSelection, destination: {
          OptionListView(
            product: products.products[index],
            optionSelection: optionSelection,
            productSelection: productSelection ?? 0
          )
        }, label: {
          HStack {
            Image(systemName: products.products[index].type)
            Text(products.products[index].name)
          }
          .onTapGesture {
            productSelection = index
            optionSelection = 0
          }
          .font(.title2)
          .padding()
        })
      }
      .frame(minWidth: 250)
    }
    .padding([.leading, .bottom, .top])
    .frame(width: 800, height: 500, alignment: .topLeading)
    .listStyle(.inset(alternatesRowBackgrounds: true))
  }
}

struct ProductSelectorView_Previews: PreviewProvider {
  static var previews: some View {
    ProductConfiguratorView()
  }
}

struct OptionSelectionView: View {
  @State var option: Option
  var body: some View {
    HStack {
      VStack(alignment: .leading) {
        if option.primaryColorIdentifier != nil {
          VStack(alignment: .leading) {
            HStack {
              Image(systemName: "paintbrush")
              Text(option.colorDisplayName!).font(.title3)
              Circle().fill(Color(option.primaryColorIdentifier!))
                .frame(width: 20, height: 20).overlay(Circle().stroke(Color.gray, lineWidth: 1))
            }.font(.title2)
            Spacer()
          }.padding(2)
        }
        if option.processor != nil {
          VStack(alignment: .leading) {
            HStack {
              Image(systemName: "cpu")
              Text(option.processor!).font(.title3)
            }.font(.title2)
            Spacer()
          }.padding(2)
        }
        if option.memory != nil {
          VStack(alignment: .leading) {
            HStack {
              Image(systemName: "memorychip")
              Text(option.memory!).font(.title3)
            }.font(.title2)
            Spacer()
          }.padding(2)
        }
        if option.storage != nil {
          VStack(alignment: .leading) {
            HStack(alignment: .center) {
              Image(systemName: "internaldrive")
              Text(option.storage!).font(.title3)
            }.font(.title2)
            Spacer()
          }.padding(2)
        }
        if option.glass != nil {
          VStack(alignment: .leading) {
            HStack(alignment: .center) {
              Image(systemName: "sparkles.tv")
              Text(option.glass!).font(.title3)
            }.font(.title2)
            Spacer()
          }.padding(2)
        }
        if option.stand != nil {
          VStack(alignment: .leading) {
            HStack(alignment: .center) {
              Image(systemName: "display.and.arrow.down")
              Text(option.stand!).font(.title3)
            }.font(.title2)
            Spacer()
          }.padding(2)
        }
      }
      Spacer()
    }
    .frame(width: 400)
    .padding().background(RoundedRectangle(cornerRadius: 5).foregroundColor(.secondary).opacity(0.1))
  }
}

struct OptionListView: View {
  @Environment(\.presentationMode) var presentationMode
  @EnvironmentObject var userDataStore: UserDataStore
  @EnvironmentObject var products: ProductStore
  @State var product: Product
  @State var optionSelection: Int = 0
  var productSelection: Int = 0
  var body: some View {
    ScrollViewReader { scrollViewProxy in
      ScrollView {
        VStack(alignment: .leading) {
          Text(product.name)
            .font(.title)
            .padding(.bottom)
          ForEach(product.options.indices, id: \.self) { index in
            OptionSelectionView(option: product.options[index])
              .selectable(
                selection: $optionSelection,
                tag: index,
                shape: AnyShape(RoundedRectangle(cornerRadius: 5)),
                strokeTint: .accentColor,
                stokeWidth: 2
              )
          }
        }
        .padding()
      }.onAppear(
        perform: {
          if optionSelection != 0 {
            scrollViewProxy.scrollTo(optionSelection)
          }
        }
      )
    }
    HStack {
      Spacer()
      Button(action: {
        self.presentationMode.wrappedValue.dismiss()
      }, label: {Text("Cancel")}).keyboardShortcut(.cancelAction)
      Button(action: {
        userDataStore.addProduct(product: TrackedProduct(
          name: products.products[productSelection].name,
          identifier: products.products[productSelection].options[optionSelection].identifier
        ))
        self.presentationMode.wrappedValue.dismiss()
      }, label: {
        Text("Add")
      }).keyboardShortcut(.defaultAction)
    }
    .padding(10)
  }
}
