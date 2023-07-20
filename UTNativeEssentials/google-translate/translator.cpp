#include "google/cloud/translate/v3/translation_client.h"
#include "google/cloud/project.h"
#include <iostream>

auto constexpr kText = R"""(
Four score and seven years ago our fathers brought forth on this
continent, a new nation, conceived in Liberty, and dedicated to
the proposition that all men are created equal.)""";

int main(int argc, char* argv[]) try {
    if (argc < 2 || argc > 3) {
        std::cerr << "Usage: " << argv[0] << " project-id "
            << "[target-language (default: es-419)]\n";
        return 1;
    }

    namespace translate = ::google::cloud::translate_v3;
    auto client = translate::TranslationServiceClient(
        translate::MakeTranslationServiceConnection());

    auto const project = google::cloud::Project(argv[1]);
    auto const target = std::string{ argc >= 3 ? argv[2] : "es-419" };
    auto response =
        client.TranslateText(project.FullName(), target, { std::string{kText} });
    if (!response) throw std::move(response).status();

    for (auto const& translation : response->translations()) {
        std::cout << translation.translated_text() << "\n";
    }

    return 0;
}
catch (google::cloud::Status const& status) {
    std::cerr << "google::cloud::Status thrown: " << status << "\n";
    return 1;
}