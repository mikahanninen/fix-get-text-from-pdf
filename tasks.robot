*** Settings ***
Library     RPA.PDF
Library     Collections
Library     RPA.FileSystem
Library     RPA.Browser.Selenium


*** Tasks ***
Minimal task
    # https://robocorp-developers.slack.com/archives/C04Q6UBN8RJ/p1677103974115769
    # Problem with Get Text With PDF (inconsistent order of data)
    # Problem with Find Text (does not find all fields)
    ${files}=    List Files In Directory    ${CURDIR}${/}resources
    FOR    ${index}    ${file}    IN ENUMERATE    @{files}
        ${text}=    Get Text From Pdf    ${file}    details=True
        Log To Console    FILE: ${file}
        Log to Console    ${{"-"*40}}
        ${print_next}=    Set Variable    ${NONE}
        FOR    ${text_index}    ${tb}    IN ENUMERATE    @{text}[${1}]
            IF    $text_index == 0
                Log To Console    EXPECTED INVOICE == ${tb.text}
            ELSE IF    $text_index == 4
                Log To Console    EXPECTED INVOICE DATE == ${tb.text}
            ELSE IF    $text_index == 6
                Log To Console    EXPECTED ACCOUNT#: == ${tb.text}
            END
            IF    "${print_next}" != "${NONE}"
                Log To Console    EXPECTED ${print_next} == ${tb.text}
                ${print_next}=    Set Variable    ${NONE}
            END
            IF    "Invoice Sale Amount:" == $tb.text
                ${print_next}=    Set Variable    ${tb.text}
            END
        END
        Log to Console    ${{"-"*40}}
    END
    Log    Done.
