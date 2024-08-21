import requests
import json
import pandas as pd

URL_PESQUISA: str = (
    "https://api.mercadolibre.com/sites/MLA/search?q={}&limit={}&offset={}"
)
URL_ITEMS: str = "https://api.mercadolibre.com/items/{}"
NOME_ARQUIVO_CSV: str = "resultado.csv"


def montar_url_pesquisa(url_base: str, termo_busca: str, limite: int, offset: int):
    texto_retorno = url_base.format(termo_busca, limite, offset)
    print(f"Pesquisa: {texto_retorno}")
    return texto_retorno


def montar_url_items(url_base: str, item_id: str):
    texto_retorno = url_base.format(item_id)
    print(f"Item: {texto_retorno}")
    return texto_retorno


def fazer_request(url: str, metodo: str):
    # print("url: " + url)  # para debug apenas
    texto_retorno = None
    try:
        if metodo == "GET":
            texto_retorno: requests.Response = requests.get(url).text
        else:
            raise Exception(f"Método não reconhecido: {metodo}")
    except Exception as e:
        raise Exception(
            f"Erro no {metodo} para {url}: {texto_retorno.status_code}"
        ) from e

    return texto_retorno


def parsear_json(texto_json: str):
    dicionario: dict = json.loads(texto_json)
    return dicionario


if __name__ == "__main__":

    resultados_finais: list = []
    ids_acumulados: set = set()  # Set para evitar duplicidade

    # Para cada termo de busca
    for termo_busca in ["Apple", "Samsung", "Motorola"]:

        # Para cada página de 50 items
        for pagina in [0, 1]:

            # Montar e chamar URL de pesquisa
            url_pesquisa: str = montar_url_pesquisa(
                URL_PESQUISA, termo_busca, limite=50, offset=pagina * 50
            )
            retorno: str = fazer_request(url_pesquisa, "GET")

            # Converter o conteúdo em uma lista python (set para tirar possíveis duplicidades)
            retorno_parseado: dict = parsear_json(retorno)
            lista_resultados: list = retorno_parseado["results"]
            lista_ids: set = {resultado["id"] for resultado in lista_resultados}

            # Acumula os ids encontrados
            ids_acumulados = ids_acumulados.union(lista_ids)

    # Para cada id único encontrado na busca anterior
    for id in ids_acumulados:

        # Montar e chamar URL de item
        url_item = montar_url_items(URL_ITEMS, id)
        retorno: str = fazer_request(url_item, "GET")

        # Converter o conteúdo em uma lista python
        item = parsear_json(retorno)
        resultados_finais.append(item)

    # Gerar CSV final usando Pandas dataframes
    pandas_df: pd.DataFrame = pd.DataFrame.from_dict(resultados_finais)
    pandas_df.to_csv(NOME_ARQUIVO_CSV, sep=";", index=False, header=True)

    print(
        f"Arquivo {NOME_ARQUIVO_CSV} gerado, contendo {pandas_df.shape[0]} linhas/{pandas_df.shape[1]} colunas"
    )
