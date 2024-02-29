from langchain.vectorstores.qdrant import Qdrant
from langchain.embeddings import HuggingFaceEmbeddings
from langchain_openai.embeddings.azure import AzureOpenAIEmbeddings


from glob import glob
import pandas as pd
from ast import literal_eval

DATA_ROOT_PATH = "../../../data"

data = pd.read_csv(f"{DATA_ROOT_PATH}/vector_database_wikipedia_articles_embedded.csv")
# data["title_vector"] = data.title_vector.apply(literal_eval)
# data["content_vector"] = data.content_vector.apply(literal_eval)

# glob("../../../data/vector_database_wikipedia_articles_embedded.csv")




embedding = AzureOpenAIEmbeddings(
    deployment="corus-embedding-dev",
    model="text-embedding-ada-002",
    azure_endpoint="https://openai-corus-gpt4-0.openai.azure.com/",
    openai_api_key="2d3bfadddfbd4742964eda28465954d3",
    openai_api_version="2023-12-01-preview"
)

doc_store = Qdrant.from_texts(
    data["text"],
    embedding,
    url="http://app.dev.corus-ai.net:32660",
    api_key="corusqdrantapikey",
    collection_name="wikipedia_text",
)

# pip install unstructured
from langchain_community.document_loaders import TextLoader, DirectoryLoader

loader = DirectoryLoader(
    path=f"{DATA_ROOT_PATH}/TS_02.법률",
    glob="**/*.txt",
    loader_cls=TextLoader,
    show_progress=True,
)
documents = loader.load()

loader = TextLoader(f"{DATA_ROOT_PATH}/TS_02\.법률")
# documents = loader.load()
# documents = loader.load_and_split()
# qdrant = Qdrant.from_documents(
#     data["text"],
#     embedding,
#     url="app.dev.corus-ai.net:32660",
#     prefer_grpc=True, 
#     collection_name="wikipedia_doc",
# )


import qdrant_client

def gen_embedding(t: str):
    return embedding.embed_query(t)

qdrant = qdrant_client.QdrantClient(url="http://app.dev.corus-ai.net", port=32660)
result = qdrant.search(
    collection_name='wikipedia_text',
    query_vector=(
        gen_embedding('smartphone')
    ),
    limit=10,
)


from langchain.vectorstores.opensearch_vector_search import OpenSearchVectorSearch

# doc_store = OpenSearchVectorSearch.from_texts(
#     texts=data["text"],
#     embedding=embedding,
#     opensearch_url="http://app.dev.corus-ai.net:30920",
#     http_auth=("admin", "admin"),
#     index_name="wikipedia_text",
#     bulk_size=len(data["text"]),
#     use_ssl=False,
#     verify_certs=False,
#     ssl_assert_hostname=False,
#     ssl_show_warn=False,
# )
BULK_SIZE = 100
for i in range(int(len(data["text"]) / BULK_SIZE)):
    _t = data["text"][:BULK_SIZE]
    bulk_size = len(_t)
    if i < 1:
        oss = OpenSearchVectorSearch.from_texts(
            texts=_t,
            embedding=embedding,
            opensearch_url="http://app.dev.corus-ai.net:30920",
            http_auth=("admin", "admin"),
            index_name="wikipedia_text",
            bulk_size=len(_t),
            use_ssl=False,
            verify_certs=False,
            ssl_assert_hostname=False,
            ssl_show_warn=False,
        )
    else:
        oss.add_texts(
            texts=_t,
            embedding=embedding,
            opensearch_url="http://app.dev.corus-ai.net:30920",
            http_auth=("admin", "admin"),
            index_name="wikipedia_text",
            bulk_size=len(_t),
            use_ssl=False,
            verify_certs=False,
            ssl_assert_hostname=False,
            ssl_show_warn=False,
        )
# OpenSearchVectorSearch(
#     url="http://localhost:9200",
#     index_name="my_index",
#     embedding_field="embedding"
# )