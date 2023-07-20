#[[
    Abstractions and Models are NOT at WAR!
                                            - Cobwoy's Talisman
    But Abstractions don't care and Models can't understand!!
                                            - Lul, Practicality
 ]]

cmake_minimum_required(VERSION 3.0.0)

project(Google-Translate)

file(GLOB_RECURSE GT_SOURCE *.cpp)

add_executable(GoogleTranslate ${GT_SOURCE})

target_link_libraries(GoogleTranslate optimized google-cloud-cpp::translate)
