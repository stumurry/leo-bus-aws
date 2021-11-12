module.exports = {
  Parameters: {
    GitUrl: {
      Description: 'Config dek base64',
      Type: 'String',
      Default: ''
    },
    GitSecret: {
      Description: 'Config base64 encoded',
      Type: 'String',
      Default: ''
    }
  },
  Mappings: {
    VpcMap: {
      local: {
        securityGroups: [
          'sg-2e407650',
          'sg-a94c7ad7'
        ],
        subnets: [
          'subnet-344c2e6e',
          'subnet-8f921bf6',
          'subnet-d66fc49d'
        ]
      },
      dev: {
        securityGroups: [
          'sg-2e407650',
          'sg-a94c7ad7'
        ],
        subnets: [
          'subnet-344c2e6e',
          'subnet-8f921bf6',
          'subnet-d66fc49d'
        ]
      },
      tst: {
        securityGroups: [
          'sg-3f91344e',
          'sg-4b9e3b3a'
        ],
        subnets: [
          'subnet-bba820c2',
          'subnet-fa65cfb1',
          'subnet-68690432'
        ]
      },
      prd: {
        securityGroups: [
          'sg-3f91344e',
          'sg-4b9e3b3a'
        ],
        subnets: [
          'subnet-bba820c2',
          'subnet-fa65cfb1',
          'subnet-68690432'
        ]
      }
    }
  }
}
