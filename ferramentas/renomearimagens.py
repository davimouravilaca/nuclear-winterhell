import os

# Pasta onde as imagens estão localizadas
pasta_imagens = "C:/Users/Davi Moura/Documents/projeto-rpgmaker/nuclearwinterhell/Graphics/Characters"

# Palavra que você deseja remover dos nomes das imagens
palavra_a_remover = "AnyConv.com_"

# Listar todos os arquivos na pasta das imagens
arquivos = os.listdir(pasta_imagens)

# Iterar sobre os arquivos
for arquivo in arquivos:
    # Verificar se o arquivo é uma imagem (você pode adicionar mais extensões se necessário)
    if arquivo.lower().endswith(('.png', '.jpg', '.jpeg', '.gif')):
        # Obter o novo nome do arquivo removendo a palavra
        novo_nome = arquivo.replace(palavra_a_remover, "")
        
        # Caminho completo do arquivo original e do novo arquivo
        caminho_original = os.path.join(pasta_imagens, arquivo)
        caminho_novo = os.path.join(pasta_imagens, novo_nome)
        
        # Renomear o arquivo
        os.rename(caminho_original, caminho_novo)
        
        print(f"Renomeado: {arquivo} -> {novo_nome}")

        
