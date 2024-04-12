FROM dhiway/cord:develop
USER ubuntu
ARG KEY=0
ARG SPEC_FOLDER_NAME=cssp
COPY ./cord/scripts/node$KEY.key /cord/
COPY ./cord/scripts/accounts.txt /cord/
COPY ./cord/scripts/$SPEC_FOLDER_NAME-raw-spec.json /cord/
RUN chmod -R 0777 /cord
