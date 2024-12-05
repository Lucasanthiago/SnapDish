import SwiftUI

struct LoadingImageView: View {
    @State private var animationProgress: CGFloat = 1.0 // Começa oculto
    @Environment(\.colorScheme) var colorScheme // Detecta o modo de cor atual

    var body: some View {
        VStack {
            Spacer() // Espaçamento acima da imagem
            
            ZStack(alignment: .bottom) {
                Image(colorScheme == .dark ? "LogoLoadingDark" : "LogoLoadingLight") // Alterna entre imagens
                    .resizable()
                    .scaledToFit()
                    .frame(height: 212) // Define a altura da imagem
                    .clipShape(Rectangle()
                        .offset(y: animationProgress * 300) // Controla o corte de baixo para cima
                    )
                    .animation(.easeInOut(duration: 3), value: animationProgress) // Animação suave
            }

            Spacer() // Espaçamento abaixo da imagem
        }
        .onAppear {
            // Quando a view aparece, inicia a animação
            animationProgress = 0.0
        }
    }
}

struct LoadingImageView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            LoadingImageView()
                .preferredColorScheme(.light) // Preview no modo claro
            
            LoadingImageView()
                .preferredColorScheme(.dark) // Preview no modo escuro
        }
    }
}
