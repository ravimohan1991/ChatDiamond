#[[
    Abstractions and Models are NOT at WAR!
                                            - Cobwoy's Talisman
    But Abstractions don't care and Models can't understand!!
                                            - Lul, Practicality
 ]]

cmake_minimum_required(VERSION 3.0.0)

# Introducing the same directory hierarchy in the solution projects (for MSVC and Xcode)
# Snippet gracefully taken from https://blog.audio-tk.com/2015/09/01/sorting-source-files-and-projects-in-folders-with-cmake-and-visual-studioxcode/
MACRO(SOURCE_GROUP_BY_FOLDER Target)
    SET(SOURCE_GROUP_DELIMITER "/")
    SET(Last_Dir "")
    SET(Files "")
    FOREACH(File ${CD_SOURCE} ${CD_HEADERS})
        FILE(RELATIVE_PATH Relative_File "${PROJECT_SOURCE_DIR}/${Target}" ${File})
        GET_FILENAME_COMPONENT(Dir "${Relative_File}" PATH)
        IF (NOT "${Dir}" STREQUAL "${Last_Dir}")
            IF (Files)
                SOURCE_GROUP("${Last_Dir}" FILES ${Files})
            ENDIF (Files)
            SET(Files "")
        ENDIF (NOT "${Dir}" STREQUAL "${Last_Dir}")
        SET(Files ${Files} ${File})
        SET(Last_Dir "${Dir}")
    ENDFOREACH(File)
    IF (Files)
        SOURCE_GROUP("${Last_Dir}" FILES ${Files})
    ENDIF (Files)
ENDMACRO(SOURCE_GROUP_BY_FOLDER)

project(ChatDiamond)

file(GLOB_RECURSE CD_HEADERS Inc/*.h Inc/*.hpp)
file(GLOB_RECURSE CD_SOURCE Src/*.cpp Src/*.cc)

# Organize the files in relevant groups
SOURCE_GROUP_BY_FOLDER(../)

add_library(ChatDiamond SHARED ${CD_HEADERS} ${CD_SOURCE})

# INTERFACE (Something that Consumers require but Producers don't)
# Since I am a library coder here, I am the Producer
# Rest of the Engine is Consumer here

target_include_directories(ChatDiamond
    PRIVATE
        # where the library itself will look for its internal headers
        ${CMAKE_CURRENT_SOURCE_DIR}/Inc
		${CMAKE_CURRENT_SOURCE_DIR}/Inc/google-translate
    PUBLIC
        # where top-level project will look for the library's public headers
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/Inc>
        # where external projects will look for the library's public headers
        $<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}>
)

target_compile_definitions(ChatDiamond PUBLIC ChatDiamond)
