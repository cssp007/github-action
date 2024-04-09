FROM dhiway/cord:develop
ARG KEY=0
COPY ./cord/scripts/node$KEY.key /cord/
COPY ./cord/scripts/accounts.txt /cord/
COPY ./cord/scripts/$$SPEC_FOLDER_NAME-raw-spec.json /cord/
