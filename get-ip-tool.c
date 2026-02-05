#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <curl/curl.h>

#define API_URL "http://ip-api.com/json/"
#define BOLD "\033[1m"
#define CYAN "\033[36m"
#define RESET "\033[0m"

struct memory
{
    char *data;
    size_t size;
};

char *json_get(const char *json, const char *key)
{
    static char value[128];
    char pattern[64];

    snprintf(pattern, sizeof(pattern), "\"%s\":\"", key);
    char *start = strstr(json, pattern);
    if (!start)
        return NULL;

    start += strlen(pattern);
    char *end = strchr(start, '"');
    if (!end)
        return NULL;

    size_t len = end - start;
    if (len >= sizeof(value))
        len = sizeof(value) - 1;

    strncpy(value, start, len);
    value[len] = '\0';
    return value;
}

void print_row(const char *key, const char *value)
{
    printf("│ %s%-9s%s │ %-25s │\n", CYAN, key, RESET, value);
}

static size_t write_callback(void *contents, size_t size, size_t nmemb, void *userp)
{
    size_t realsize = size * nmemb;
    struct memory *mem = (struct memory *)userp;

    char *ptr = realloc(mem->data, mem->size + realsize + 1);
    if (!ptr)
        return 0;

    mem->data = ptr;
    memcpy(&(mem->data[mem->size]), contents, realsize);
    mem->size += realsize;
    mem->data[mem->size] = 0;

    return realsize;
}

void usage()
{
    printf("Usage:\n");
    printf("  get-ip-tool            (your public IP)\n");
    printf("  get-ip-tool -ip 8.8.8.8\n");
}

int main(int argc, char **argv)
{
    char url[256];
    snprintf(url, sizeof(url), "%s", API_URL);

    if (argc == 3 && strcmp(argv[1], "-ip") == 0)
    {
        strncat(url, argv[2], sizeof(url) - strlen(url) - 1);
    }
    else if (argc != 1)
    {
        usage();
        return 1;
    }

    CURL *curl;
    CURLcode res;
    struct memory chunk = {0};

    curl = curl_easy_init();
    if (!curl)
    {
        fprintf(stderr, "Error initializing curl\n");
        return 1;
    }

    curl_easy_setopt(curl, CURLOPT_URL, url);
    curl_easy_setopt(curl, CURLOPT_WRITEFUNCTION, write_callback);
    curl_easy_setopt(curl, CURLOPT_WRITEDATA, &chunk);
    curl_easy_setopt(curl, CURLOPT_USERAGENT, "get-ip-tool/1.0");

    res = curl_easy_perform(curl);
    if (res != CURLE_OK)
    {
        fprintf(stderr, "Request failed: %s\n", curl_easy_strerror(res));
        curl_easy_cleanup(curl);
        free(chunk.data);
        return 1;
    }

    printf("\n");
    printf("┌───────────┬───────────────────────────┐\n");

    print_row("IP", json_get(chunk.data, "query"));
    print_row("País", json_get(chunk.data, "country"));
    print_row("Región", json_get(chunk.data, "regionName"));
    print_row("Ciudad", json_get(chunk.data, "city"));
    print_row("ISP", json_get(chunk.data, "isp"));

    printf("└───────────┴───────────────────────────┘\n");

#ifdef _WIN32
    printf("\nPressione Enter para sair...");
    getchar();
#endif

    curl_easy_cleanup(curl);
    free(chunk.data);
    return 0;
}
